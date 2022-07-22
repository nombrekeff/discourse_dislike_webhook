# frozen_string_literal: true
# name: discourse_remove_like_webhook
# about: Adds a new webhook event for when a like is removed from a post
# version: 0.0.1
# authors: nombrekeff
# url: https://github.com/nombrekeff/discourse_remove_like_webhook
# required_version: 2.7.0

enabled_site_setting :discourse_remove_like_webhook_enabled

after_initialize do
  SeedFu.fixture_paths << Rails.root.join("plugins", "discourse_remove_like_webhook", "db", "fixtures").to_s
  register_seedfu_fixtures(Rails.root.join("plugins", "discourse_remove_like_webhook", "db", "fixtures").to_s)

  require_dependency 'post_actions_controller'
  class ::PostActionsController
    def destroy
      post = Post.find_by(id: params[:id].to_i)
      result = PostActionDestroyer.new(
        current_user,
        post,
        @post_action_type_id
      ).perform

      action = PostAction.where(
        user_id: current_user.id,
        post_id: post.id,
        post_action_type_id: @post_action_type_id
      ).with_deleted
      .where("deleted_at IS NOT NULL")
      .first

      WebHook.enqueue_remove_like(result.post, action)

      if result.failed?
        render_json_error(result)
      else
        render_post_json(result.post, add_raw: false)
      end
    end
  end

  class ::WebHook
    def self.enqueue_remove_like(post, action)
      if active_web_hooks('post_like_removed').exists?
        user = post.user
        group_ids = user.groups.map(&:id)
        topic = Topic.includes(:tags).joins(:posts).find_by(posts: { id: post.id })
        category_id = topic&.category_id
        tag_ids = topic&.tag_ids
      
        WebHook.enqueue_object_hooks(
          :like_removed,
          action,
          :like_removed,
          WebHookLikeSerializer,
          group_ids: group_ids,
          category_id: category_id,
          tag_ids: tag_ids
        )
      end
    end
  end
end

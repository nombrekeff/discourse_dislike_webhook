# frozen_string_literal: true
# name: discourse_remove_like_webhook
# about: Adds a new webhook event for when a like is removed from a post
# version: 0.0.1
# authors: nombrekeff
# url: https://github.com/nombrekeff/discourse_dislike_webhook
# required_version: 2.7.0

enabled_site_setting :discourse_remove_like_webhook_enabled

after_initialize do
  SeedFu.fixture_paths << Rails.root.join("plugins", "discourse_dislike_webhook", "db", "fixtures").to_s
  register_seedfu_fixtures(Rails.root.join("plugins", "discourse_dislike_webhook", "db", "fixtures").to_s)

  require_dependency 'post_actions_controller'
  class ::PostActionsController
    def destroy
      result = PostActionDestroyer.new(
        current_user,
        Post.find_by(id: params[:id].to_i),
        @post_action_type_id
      ).perform

      WebHook.enqueue_remove_like(result.post)
      if result.failed?
        render_json_error(result)
      else
        render_post_json(result.post, add_raw: false)
      end
    end
  end

  class ::WebHook
    def self.enqueue_remove_like(post)
      payload ||= WebHook.generate_payload(:post, post)
      if active_web_hooks('post_like_removed').exists?
        WebHook.enqueue_hooks(
          :post_like_removed,
          :post_like_removed,
          id: post.id,
          payload: {
            post: post,
            user: {
              id: post.user.id,
              username: post.user.username,
            },
          }.to_json,
        )
      end
    end
  end
end

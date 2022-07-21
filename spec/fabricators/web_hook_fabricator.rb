# frozen_string_literal: true
Fabricator(:post_like_removed_web_hook, from: :web_hook) do
  transient post_like_removed_hook: WebHookEventType.find_by(name: 'post_like_removed')

  after_build do |web_hook, transients|
    web_hook.web_hook_event_types = [transients[:post_like_removed_hook]]
  end
end

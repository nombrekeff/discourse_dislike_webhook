# frozen_string_literal: true

describe "Emits webhook" do
  # let(:topic) { Fabricate(:topic) }
  # let(:user) { Fabricate(:moderator) }
  # let(:p1) { Fabricate(:post, topic: topic) }

  # before do
  #   SiteSetting.discourse_remove_like_webhook_enabled = true
  #   sign_in(user)
  # end

  # it 'triggers a webhook' do
  #   Fabricate(:post_like_removed_web_hook)
    
  #   # Creates like
  #   post "/post_actions.json", params: { id: p1.id, post_action_type_id: PostActionType.types[:like] }
  #   expect(response.status).to eq(200)
  #   parsed_action = response.parsed_body
  #   print parsed_action
    
  #   # Removes like
  #   delete "/post_actions/#{parsed_action['id']}.json", params: { post_action_type_id: PostActionType.types[:like] }
  #   expect(response.status).to eq(200)

  #   # job_args = Jobs::EmitWebHookEvent.jobs[0]["args"].first

  #   # expect(job_args["event_name"]).to eq("post_like_removed")
  #   # payload = JSON.parse(job_args["payload"])
  #   # expect(payload["user"]["post_like_removed"]["id"]).to eq(user.id)
  #   # expect(payload["post_like_removed"]["post"]["id"]).to eq(p1.id)
  # end
end
    
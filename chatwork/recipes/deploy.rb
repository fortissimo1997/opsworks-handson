node[:deploy].each do |application, deploy|
  token = deploy[:chatwork_token]
  room  = deploy[:chatwork_room_id]
  return true if token.nil? || room.nil?
  return true if deploy[:scm].nil? || deploy[:deploying_user].nil?
  user = deploy[:deploying_user].split('/')[1]
  Log.logger.info "deploy[:notifying_nodes]"
  Log.logger.info deploy[:notifying_nodes]
  return true if deploy[:notifying_nodes].nil?
  return true unless deploy[:notifying_nodes].kind_of?(Array)
  return true if deploy[:notifying_nodes].include?(node[:hostname])

  execute 'post notification to chatwork' do
    command "curl -X POST -H \"X-ChatWorkToken: #{token}\" -d \"body=Application+#{application}+deployed+by+#{user}\" \"https://api.chatwork.com/v1/rooms/#{room}/messages\""
    action :run
  end
end

# name: discourse-group-membership-ip-block
# about: Adds list of ip blocks that users starting sessions from will join the group
# version: 0.1
# authors: Falco
# url: https://github.com/discourse/discourse-group-membership-ip-block

enabled_site_setting :group_membership_ip_block_enabled
register_asset 'stylesheets/group-settings.scss'

after_initialize do
  DiscoursePluginRegistry.register_editable_group_custom_field(:ip_blocks_list, self)
  register_group_custom_field_type('ip_blocks_list', :list)
  add_to_serializer(:basic_group, :custom_fields) { object.custom_fields }


  on(:user_logged_in) do |user|
    return unless SiteSetting.group_membership_ip_block_enabled

    GroupCustomField.where(name: 'ip_blocks_list').each do |rule|
      ips = rule.value.split.map{|ip| IPAddr.new(ip)}
      ips.each do |ip|
        Group.find_by(id: rule.group).add(user) if ip.include?(user.ip_address)
      end
    end
  end
end
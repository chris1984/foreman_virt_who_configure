class AddProviderToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :foreman_virt_who_configure_service_users, :provider_type, :string
    add_column :foreman_virt_who_configure_service_users, :provider_name, :string
    add_column :foreman_virt_who_configure_service_users, :organization_id, :integer

    configs = ForemanVirtWhoConfigure::Config.all

    if configs.present?
      configs.each do |config|
        provider_type = config.hypervisor_type
        provider_name = config.hypervisor_server
        org_id = config.organization_id
        account = config.service_user_id
        service_user = ForemanVirtWhoConfigure::ServiceUser.where(id: account)

        service_user.first.provider_type = provider_type
        service_user.first.provider_name = provider_name
        service_user.first.organization_id = org_id
        service_user.first.save
      end
    end
  end
end

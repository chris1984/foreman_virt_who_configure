class AddProviderToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :foreman_virt_who_configure_service_users, :provider, :string

    configs = ForemanVirtWhoConfigure::Config.all
    if configs.present?
      configs.each do |config|
        provider_type = config.hypervisor_type
        account = config.service_user_id
        service_user = ForemanVirtWhoConfigure::ServiceUser.where(id: account)
        service_user.provider = provider_type
        service_user.save
      end
    end
  end
end

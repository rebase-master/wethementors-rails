ActiveAdmin.register User do
  menu priority: 1

  actions :index, :show, :edit, :update

  filter :email
  filter :first_name
  filter :last_name
  filter :role, as: :select, collection: User.roles.keys
  filter :status, as: :select, collection: User.statuses.keys
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    id_column
    column :email
    column :first_name
    column :last_name
    column :role
    column :status
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :email
      row :first_name
      row :last_name
      row :role
      row :status
      row :created_at
      row :updated_at
      row :last_sign_in_at
      row :last_sign_in_ip
    end
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :first_name
      f.input :last_name
      f.input :role, as: :select, collection: User.roles.keys
      f.input :status, as: :select, collection: User.statuses.keys
    end
    f.actions
  end

  member_action :activate, method: :post do
    resource.activate!
    redirect_to resource_path, notice: "User has been activated."
  end

  member_action :deactivate, method: :post do
    resource.deactivate!
    redirect_to resource_path, notice: "User has been deactivated."
  end

  member_action :block, method: :post do
    resource.block!
    redirect_to resource_path, notice: "User has been blocked."
  end

  member_action :unblock, method: :post do
    resource.unblock!
    redirect_to resource_path, notice: "User has been unblocked."
  end

  action_item :activate, only: :show do
    link_to "Activate", activate_admin_user_path(resource), method: :post if resource.inactive?
  end

  action_item :deactivate, only: :show do
    link_to "Deactivate", deactivate_admin_user_path(resource), method: :post if resource.active?
  end

  action_item :block, only: :show do
    link_to "Block", block_admin_user_path(resource), method: :post unless resource.blocked?
  end

  action_item :unblock, only: :show do
    link_to "Unblock", unblock_admin_user_path(resource), method: :post if resource.blocked?
  end

  controller do
    def update
      if params[:user][:password].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end
      super
    end
  end
end 
ActiveAdmin.register Subject do
  permit_params :name, :description, :order

  index do
    selectable_column
    id_column
    column :name
    column :order
    column :created_at
    actions
  end

  filter :name
  filter :order
  filter :created_at

  form do |f|
    f.inputs do
      f.input :name
      f.input :description, as: :text
      f.input :order
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :description
      row :order
      row :created_at
      row :updated_at
    end

    panel "Topics" do
      table_for subject.topics do
        column :title
        column :order
        column :created_at
      end
    end
  end
end 
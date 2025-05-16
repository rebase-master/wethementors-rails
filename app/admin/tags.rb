ActiveAdmin.register Tag do
  permit_params :name

  index do
    selectable_column
    id_column
    column :name
    column :questions_count do |tag|
      tag.questions.count
    end
    column :created_at
    actions
  end

  filter :name
  filter :created_at

  form do |f|
    f.inputs do
      f.input :name
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :created_at
      row :updated_at
    end

    panel "Questions" do
      table_for tag.questions do
        column :title
        column :user
        column :created_at
      end
    end
  end
end 
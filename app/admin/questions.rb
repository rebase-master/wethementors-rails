ActiveAdmin.register QaQuestion do
  permit_params :title, :body, :user_id, :topic_id, :status, tag_ids: []

  index do
    selectable_column
    id_column
    column :title
    column :user
    column :topic
    column :status
    column :created_at
    actions
  end

  filter :title
  filter :user
  filter :topic
  filter :status
  filter :created_at
  filter :tags

  form do |f|
    f.inputs do
      f.input :title
      f.input :body, as: :text
      f.input :user
      f.input :topic
      f.input :status, as: :select, collection: QaQuestion.statuses.keys
      f.input :tags, as: :select, input_html: { multiple: true }
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :title
      row :body
      row :user
      row :topic
      row :status
      row :created_at
      row :updated_at
    end

    panel "Tags" do
      table_for qa_question.tags do
        column :name
      end
    end

    panel "Comments" do
      table_for qa_question.comments do
        column :user
        column :body
        column :created_at
      end
    end
  end
end 
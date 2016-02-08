class CreateWithPaperclips < ActiveRecord::Migration
  def change
    create_table :with_paperclips do |t|
      t.attachment :pdf
    end
  end
end

class CreateUsersAndTwitterAuthorizations < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email, unique: true, null: false
      t.string :password_digest, null: false
      t.timestamps
    end

    create_table :twitter_authorizations do |t|
      t.references :user, foreign_key: {on_delete: :cascade}
      t.string :oauth_token, null: false
      t.string :oauth_token_secret, null: false
      t.string :twitter_user_id, null: false
      t.string :handle, null: false
      t.timestamps

      t.index [:user_id, :twitter_user_id], unique: true
    end

    create_table :toots do |t|
      t.references :user, foreign_key: {on_delete: :cascade}
      t.references :twitter_authorization, null: false, foreign_key: {on_delete: :cascade}
      t.string :text, null: false
      t.string :tweet_id, null: true, unique: true
      t.datetime :sent_to_twitter_at
      t.timestamps
    end
  end
end

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 20_250_308_192_322) do
  create_schema 'auth'
  create_schema 'extensions'
  create_schema 'graphql'
  create_schema 'graphql_public'
  create_schema 'pgbouncer'
  create_schema 'realtime'
  create_schema 'storage'
  create_schema 'vault'

  # These are extensions that must be enabled in order to support this database
  begin
    enable_extension 'pg_graphql'
  rescue ActiveRecord::StatementInvalid => e
    warn "Skipping enable_extension 'pg_graphql': #{e.class}: #{e.message}"
  end
  enable_extension 'pg_stat_statements'
  enable_extension 'pgcrypto'
  enable_extension 'plpgsql'
  enable_extension 'supabase_vault'
  enable_extension 'uuid-ossp'

  create_table 'audios', force: :cascade do |t|
    t.string 'title'
    t.string 'url'
    t.text 'description'
    t.integer 'duration'
    t.string 'audio_type'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'devise_api_tokens', force: :cascade do |t|
    t.string 'resource_owner_type', null: false
    t.bigint 'resource_owner_id', null: false
    t.string 'access_token', null: false
    t.string 'refresh_token'
    t.integer 'expires_in', null: false
    t.datetime 'revoked_at'
    t.string 'previous_refresh_token'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['access_token'], name: 'index_devise_api_tokens_on_access_token'
    t.index ['previous_refresh_token'], name: 'index_devise_api_tokens_on_previous_refresh_token'
    t.index ['refresh_token'], name: 'index_devise_api_tokens_on_refresh_token'
    t.index %w[resource_owner_type resource_owner_id], name: 'index_devise_api_tokens_on_resource_owner'
  end

  create_table 'images', force: :cascade do |t|
    t.string 'title'
    t.string 'src'
    t.string 'description'
    t.string 'category'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'user_preferences', force: :cascade do |t|
    t.bigint 'user_id', null: false
    t.float 'volume'
    t.string 'selected_track'
    t.integer 'image_transition_interval'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_user_preferences_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.boolean 'email_notifications_enabled', default: true
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
  end

  add_foreign_key 'user_preferences', 'users'
end

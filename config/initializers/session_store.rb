# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_camtweet_session',
  :secret      => '99bf0e5a25bcde95e12bbd02ab74111dbce911525461f5b9d2cb6a419a64ef39929974a3190331e804c5ea48f758fae67d9243cb5bf4335aa7cf6f5c3fdf1cbc'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
ActionController::Base.session_store = :active_record_store

# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_CarPoolService_session',
  :secret      => '9ce7e3be98b51d014b1a03b7f1340ff243866c75fd4859f69cfe97f2cee4444ca1097139bf11d2b5e987d012c1ec28ade9fc003f253a23c7fa85603008e41d93'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

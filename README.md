# Omniauth::Multiprovider


An easy way to authenticate users through many oauth providers (i.e. facebook, twitter, github and custom providers)

No more OmniauthCallbacksController, no more complex method to relate users with tokens

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omniauth-multiprovider'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omniauth-multiprovider

## Disclaimer

This is a work in progress. Expect serious refactors, breaking changes.

I am almost sure that this gem will not work outside an Rails project. Sorry Sinatra lovers... I will try to remove any DHH opinion ;)

## Usage

In your devise resource model (aka mapping), usually `User` add:

    include OmniAuth::MultiProvider::OmniAuthenticable

Don't forget to configure devise to use Facebook (or any other provider):

    devise :omniauthable, omniauth_providers: [:facebook]

In your `routes.rb`

    devise_for :users, controllers: { omniauth_callbacks: 'omni_auth/multi_provider/callbacks' }

Create a migration to add the `Authentication` model with:

    rails g migration create_authentications

The change method should contain something like:

    create_table :authentications do |t|
      t.references :{devise_mapping_name}, polymorphic: true
      t.string :uid,              null: false
      t.string :provider,         null: false
      t.string :access_token
      t.string :permissions
      t.timestamps
    end

    add_index :authentications, [:provider, :uid], unique: true

**devise_mapping_name** is probably `user`

### Errors and handling

There are 3 error scenarios:

* The oauth authentication already exists and belongs to the current logged-in user (it's trying to reconnect)
* The oauth authentication already exists and belongs to a different user (potential identity theft attemp)
* The oauth-provided email is already in use

The first error will be ignored by default.

For the other two errors `OmniAuth::MultiProvider::CallbacksController` will set the `flash[:alert]` to the localized I18N keys:

* common prefix: `devise.callbacks.user`
  * `bound_to_other`
  * `email_taken`


## Testing

Run `rspec`.

More tests are appreciated.

##Contributors

[German DZ](https://twitter.com/GermanDZ)
[Abel Muiño](https://twitter.com/amuino)

## License

MIT License.


## Contributing

1. Fork it ( https://github.com/[my-github-username]/omniauth-multiprovider/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

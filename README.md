omniauth-multiprovider
======================

An easy way to authenticate users through many oauth providers (i.e. facebook, twitter, github and custom providers)

No more OmniauthCallbacksController, no more complex method to relate users with tokens

## Disclaimer

This is a work in progress. Expect serious refactors, breaking changes.

I am almose sure that this gem will not work outside an Rails project. Sorry Sinatra lovers... I will try to remove any DHH opinion ;)

## How to use

In your devise resource model (aka mapping), usually `User` add:

    include OmniAuth::MultiProvider::OmniAuthenticable
    add_omniauth_providers :facebook, :guests

Don't forget to configure devise to use Facebook (or any other provider):

    devise :omniauthable, omniauth_providers: [:facebook]

In your `routes.rb`

    devise_for :users, controllers: { omniauth_callbacks: 'omni_auth/multi_provider/callbacks' }

Create a migration to add the `Authentication` model with:

    create_table :authentications do |t|
      t.references :{devise_mapping_name}
      t.string :uid,              :null => false
      t.string :provider,         :null => false
      t.string :access_token
      t.string :permissions

      t.timestamps
    end

**devise_mapping_name** is probably `user`

## Testing

I am porting this gem from an existing project, the testing is currently embebed in the project. I will extract those test and cover this project.

##Contributors

[German DZ](https://twitter.com/GermanDZ)

## License

MIT License.
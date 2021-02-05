class TwitterAuthorizationsController < ApplicationController
  def index
    @twitter_authorizations = TwitterAuthorization.where(user: @current_user)
  end

  def create
    request_token = TwitterOauth.request_token
    session[:oauth_token] = request_token.oauth_token
    session[:oauth_token_secret] = request_token.oauth_token_secret

    redirect_to request_token.login_url
  end

  def callback
    raise "OAuth Request Token mismatch" unless session[:oauth_token] == params[:oauth_token]

    access_token = TwitterOauth.access_token(
      oauth_token: session[:oauth_token],
      oauth_token_secret: session[:oauth_token_secret],
      oauth_verifier: params[:oauth_verifier]
    )
    twitter_authorization = TwitterAuthorization.find_or_initialize_by(
      user: @current_user,
      twitter_user_id: access_token.user_id
    ).tap do |twitter_authorization|
      twitter_authorization.assign_attributes(
        oauth_token: access_token.oauth_token,
        oauth_token_secret: access_token.oauth_token_secret,
        handle: access_token.screen_name
      )
    end

    if twitter_authorization.save
      flash[:info] = "Signed into Twitter as @#{twitter_authorization.handle}!"
    else
      flash[:error] = "Twitter sign-in failed! #{twitter_authorization.errors.full_messages.join(", ")}"
    end

    redirect_to twitter_authorizations_path
  end

  def destroy
    twitter_authorization = @current_user.twitter_authorizations.find(params[:id])
    if twitter_authorization&.destroy
      flash[:info] = "Twitter account @#{twitter_authorization.handle} removed"
    else
      flash[:error] = "Failed to remove Twitter account"
    end

    redirect_to twitter_authorizations_path
  end
end

class TootsController < ApplicationController
  def index
    @toots = GathersToots.new.call(user: @current_user)
  end

  def edit
    @toot = @current_user.toots.find(params[:id])
  end

  def create
    @toot = @current_user.toots.new(verified_params(params))

    if @toot.save
      flash[:info] = "Toot #{@toot.draft? ? "drafted" : "saved"}!"
    else
      flash[:error] = @toot.errors.full_messages.join(", ")
    end
    redirect_to toots_path
  end

  def update
    @toot = @current_user.toots.find(params[:id])

    if @toot.update(verified_params(params))
      flash[:info] = "Toot updated!"
      redirect_to toots_path
    else
      flash[:error] = @toot.errors.full_messages.join(", ")
      render :edit
    end
  end

  private

  def verified_params(params)
    params[:toot].permit(:text, :draft).merge(
      twitter_authorization: @current_user.twitter_authorizations.find(params[:toot][:twitter_authorization_id])
    )
  end
end

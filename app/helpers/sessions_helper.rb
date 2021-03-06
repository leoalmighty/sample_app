module SessionsHelper
  
  #log in the given user
  def log_in(user)
    session[:user_id] = user.id
  end
  
  #remembers a user in a persistent session
  def remember(user)
    user.remember
    # cookies[:user_id] = { value: user.id, expires: 20.years.from_now.utc }
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  def current_user
    if (user_id = session[:user_id]) #this is an assignment of user_id
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
  #returns true if user is logged in
  def logged_in?
    !current_user.nil?
  end
  
  # forgets a persistent session
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  def log_out
    forget(current_user)
    session.delete(:user_id)
    # session[:user_id] = nil  #same as above
    @current_user = nil
  end
  
end

class AccountController < ApplicationController
  layout 'account'

  def login
    case request.method
      when :post
        if session['user'] = User.authenticate(params['user_login'], params['user_password'])

          flash['notice']  = "Login successful"
          redirect_back_or_default :controller => "notes", :action => "index"
        else
          @login    = params['user_login']
          @message  = "Login unsuccessful"
      end
    end
  end
  
  def signup
    case request.method
      when :post
        @user = User.new(params['user'])
        if @user.save      
          session['user'] = User.authenticate(@user.login, params['user']['password'])
          redirect_back_or_default :controller=> "notes", :action => "index"          
        end
      when :get
        @user = User.new
    end      
  end  
  
  def delete
    if params['id']
      @user = User.find(params['id'])
      @user.destroy
    end
    redirect_back_or_default :action => "index"
  end  
    
  def logout
    session['user'] = nil 
    @message = "You have logged out of Notable"
    render :action=>'login'
  end  
  
  def help
    render :layout=>"help"
  end
  
  def settings
    @tags=current_user.tags
    render :layout=>"settings"
  end
  
  def update_color
    tag = Tag.find_by_id(params[:tag_id])
    tag.color = params[:tag][:color]
    tag.save 
    redirect_to :action=>"settings"
  end
end

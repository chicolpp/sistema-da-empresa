#encoding: utf-8
module Casein
  class NotificationsController < Casein::CaseinController
    load_and_authorize_resource
  
    def index
      @casein_page_title = 'Notifications'
  		@notifications = Notification.order(sort_order(:title)).paginate :page => params[:page]
    end
  
    def show
      @casein_page_title = 'View notification'
      @notification = Notification.find params[:id]
    end
  
    def new
      @casein_page_title = 'Add a new notification'
    	@notification = Notification.new
    end

    def create
      @notification = Notification.new notification_params
    
      if @notification.save
        flash[:notice] = 'Notificação foi criada com sucesso!'
        redirect_to casein_dashboard_path
      else
        flash[:warning] = 'Ocorreu um erro ao salvar a notificação'
        render :action => :new
      end
    end
  
    def update
      @casein_page_title = 'Update notification'
      
      @notification = Notification.find params[:id]
    
      if @notification.update_attributes notification_params
        flash[:notice] = 'Notification has been updated'
        redirect_to casein_notifications_path
      else
        flash.now[:warning] = 'There were problems when trying to update this notification'
        render :action => :show
      end
    end
 
    def destroy
      @notification = Notification.find params[:id]

      @notification.destroy
      flash[:notice] = 'Notification has been deleted'
      redirect_to casein_notifications_path
    end
  
    private
      
      def notification_params
        params.require(:notification).permit(:title, :link, :vendedor_id, :status)
      end

  end
end
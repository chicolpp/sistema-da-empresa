class ChangeCamposCoordenadas < ActiveRecord::Migration
  def change
  	remove_column :coordenadas, :ponto_a_longitude
  	remove_column :coordenadas, :ponto_a_latitude
  	remove_column :coordenadas, :ponto_b_longitude
  	remove_column :coordenadas, :ponto_b_latitude
  	remove_column :coordenadas, :ponto_c_longitude
  	remove_column :coordenadas, :ponto_c_latitude
  	remove_column :coordenadas, :ponto_d_latitude
    
    rename_column :coordenadas, :ponto_d_longitude, :longitude
    rename_column :coordenadas, :ponto_e_latitude,  :latitude
    rename_column :coordenadas, :ponto_e_longitude, :zona
    
    change_column :coordenadas, :longitude, :string
    change_column :coordenadas, :latitude, 	:string
    change_column :coordenadas, :zona, 			:string
  end
end

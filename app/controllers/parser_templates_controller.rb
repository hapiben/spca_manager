# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components that are licensed under the MIT license or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

class ParserTemplatesController < ApplicationController
	load_and_authorize_resource

	def index
	end

	def new
	end

	def show
	end

	def edit
	end

	def destroy
		@parser_template.destroy
		redirect_to parser_templates_path
	end

	def create
		@parser_template.user_id = current_user.id
		if @parser_template.save
			redirect_to edit_parser_template_path(@parser_template.id)
		else
			render :new
		end
	end

	def update
		@parser_template.user_id = current_user.id
		if @parser_template.update_attributes(params[:parser_template])
			redirect_to edit_parser_template_path(@parser_template.id)
		else
			render :edit
		end
	end
end
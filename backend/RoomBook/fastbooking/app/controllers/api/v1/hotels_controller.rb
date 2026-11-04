module Api
  module V1
    class HotelsController < BaseController
      def index
        city = params[:city] || params[:destination]
        check_in = parse_date(params[:check_in] || params[:checkIn])
        check_out = parse_date(params[:check_out] || params[:checkOut])
        guests = params[:guests

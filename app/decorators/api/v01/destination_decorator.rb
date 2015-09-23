# Copyright © Mapotempo, 2015
#
# This file is part of Mapotempo.
#
# Mapotempo is free software. You can redistribute it and/or
# modify since you respect the terms of the GNU Affero General
# Public License as published by the Free Software Foundation,
# either version 3 of the License, or (at your option) any later version.
#
# Mapotempo is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the Licenses for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Mapotempo. If not, see:
# <http://www.gnu.org/licenses/agpl.html>
#
V01::Stores.class_eval do
  desc 'Fetch customer\'s destinations by zone.',
    nickname: 'getDestinationsByZone',
    is_array: true,
    entity: V01::Entities::Destination
  params do
    requires :zone_id, type: Integer
  end
  get :destinations_by_zone do
    zone = Zone.joins(zoning: [:customer]).where(id: params[:zone_id], zonings: {customer_id: current_customer.id}).first
    destinations = zone && current_customer.destinations.select{ |destination|
      zone.inside_distance(destination.lat, destination.lng)
    } || []
    present destinations, with: V01::Entities::Destination
  end
end

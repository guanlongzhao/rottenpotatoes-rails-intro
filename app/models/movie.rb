class Movie < ActiveRecord::Base
    def self.unique_ratings
        Movie.uniq.pluck(:rating)
    end
end

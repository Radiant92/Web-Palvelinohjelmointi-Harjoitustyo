module RatingAverage
    extend ActiveSupport::Concern
    def average_rating
        "%.4g" % (ratings.map{|rating| rating.score}.sum / ratings.count.to_f)
      end
    end
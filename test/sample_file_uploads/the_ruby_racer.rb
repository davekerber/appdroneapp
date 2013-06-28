module AppDrone
  class TheRubyRacer < Drone
    desc "Adds the therubyracer gem to your project. Useful if you are developing in Linux"
    category :misc

    depends_on :bundle

    def align
      bundle.add 'therubyracer'
    end

    def execute
    end

  end
end

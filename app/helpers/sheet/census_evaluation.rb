#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Sheet
  class CensusEvaluation < Base
    self.parent_sheet = Sheet::Group

    class Federation < Sheet::CensusEvaluation
    end

    class State < Sheet::CensusEvaluation
    end

    class Region < Sheet::CensusEvaluation
    end

    class Flock < Sheet::CensusEvaluation
    end
  end
end

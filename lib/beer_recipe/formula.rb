module BeerRecipe
  class Formula
    def ebc_to_srm(ebc)
      ebc / 1.97
    end

    def srm_to_ebc(srm)
      srm * 1.97
    end

    def mcu_to_srm(mcu)
      # SRM color = 1.4922 * (MCU ** 0.6859)
      srm = 1.4922 * (mcu ** 0.6859)
      if srm > 8
        srm
      else
        mcu
      end
    end

    def srm_to_rgb(srm)
      r = [255, [0, 255 * (0.975 ** srm)].max].min
      g = [255, [0, 245 * (0.88  ** srm)].max].min
      b = [255, [0, 220 * (0.7   ** srm)].max].min
      [r, g, b]
    end

    def mcu(amount, srm, volume)
      # MCU = (weight kg * lovibond * 2.205) / (volume * 0.264)
      (amount * srm * 2.205) / (volume * 0.264)
    end

    def sg_to_abv(og, fg)
      if og > 0 && fg > 0
        ( (76.08 * (og - fg) / (1.775 - og) ) * (fg / 0.794) )
      else
        0
      end
    end

    def calories(serving_size, abv, og, fg)
      r = real_extract(og, fg)
      ( 6.9 * ( 0.79 * ( abv / fg ) ) + 4 * ( r - 0.1 ) ) * fg * ( serving_size / 100 )
    end

    def real_extract(og, fg)
      p = (-205.35 * (og ** 2)) + (668.72 * og) - 463.37
      q = (-205.35 * (fg ** 2)) + (668.72 * fg) - 463.37
      (0.1808 * p) + (0.8192 * q)
    end
  end
end


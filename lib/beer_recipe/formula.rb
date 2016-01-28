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

    def tinseth(batch_size, boil_time, og, alpha, amount)
      # Bigness factor = 1.65 * 0.000125^(wort gravity - 1)
      # Boil Time factor = 1 - e^(-0.04 * time in mins) / 4.15
      # Decimal Alpha Acid Utilization = Bigness Factor * Boil Time Factor
      # mg/l of added alpha acids = (decimal AA rating * grams hops * 1000) / liters of wort
      # IBUs = decimal alpha acid utilization * mg/l of added alpha acids
      decimal_aa_rating = alpha / 100
      bigness_factor = 1.65 * ( 0.000125 ** (og - 1) )
      boil_time_factor = (1 - Math::E ** ( -0.04 * boil_time ) ) / 4.15
      alpha_acid_utilization = bigness_factor * boil_time_factor
      added_alpha_acids = (decimal_aa_rating * amount * 1000) / batch_size
      ibus = alpha_acid_utilization * added_alpha_acids
      return ibus
    end

    def mgl_added_alpha_acids(batch_size, alpha, amount)
      (alpha * amount) / batch_size
    end
  end
end


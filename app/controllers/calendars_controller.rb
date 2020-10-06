class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    getWeek
    @plan = Plan.new
  end

  # 予定の保存
  def create
    Plan.create(plan_params)
    redirect_to action: :index    
  end

  private

  def plan_params
    params.require(:plan).permit(:date, :plan)
  end

  def getWeek
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']

    # Dateオブジェクトは、日付を保持しています。下記のように`.today.day`とすると、今日の日付を取得できます。
    @todays_date = Date.today
    # 例)　今日が2月1日の場合・・・ Date.today.day => 1日

    @week_days = []

    plans = Plan.where(date: Date.today..Date.today + 6)

    7.times do |x|
      today_plans = []
      plan = plans.map do |plan|
        today_plans.push(plan.plan) if plan.date == Date.today + x
      end

      wday_num = Date.today.wday + x #Date.today.wdayを利用して添字となる数値を得る  
      #もしもwday_numが7以上であれば、7を引く
      if wday_num >= 7
        #条件式を記述
        wday_num = wday_num - 7
      end
      days = { month: (@todays_date + x).month, date: (@todays_date + x ).day, plans: today_plans, wday: wdays[wday_num]}#←wdaysから値を取り出す記述（wdays[添字]
      @week_days.push(days)#@week_daysの中身イメージ = [ {month: 1 , date: 2 , wday: ""}, {month: 2 , day: 2}]
      #binding.pry #@week_daysの中身本当に見たい時はここでbinding.pryを書いて止めて、試す！その時のコードは「@week_days」
    end

  end
end

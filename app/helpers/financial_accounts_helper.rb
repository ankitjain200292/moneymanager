module FinancialAccountsHelper
  
  def getAccountname(account_id)
    @account_type = AccountType.find(account_id).name
  end
  
  
  def totalPayment 
    connection = ActiveRecord::Base.connection
    @user_account = connection.execute("select sum(balance) as balance , sum(actual_payment) as actual_payment, sum(min_payment) as min_payment, sum(original_balance) as original_balance from  financial_accounts where user_id = #{current_user.id}")   
    return @user_account.first
  end
    
  def advancePayment
    
    @total_account = totalPayment
    @total_balance = @total_account[0]
    @total_payment = @total_account[1]
    @min_payment = @total_account[2]
    @original_balance = @total_account[3]
    @accountsHaveErrors = false;
    @myActualPayments = Array.new
    
    @financial_account = current_user.financial_accounts
    @actual_payment = Array.new
    @financial_account.each do |row|
      x = 0
      @payment = Array.new
      @payment.push(:company_name => row.company_name)
      @payment.push(:balance => row.balance)
      @payment.push(:original_balance => row.original_balance)
      @payment.push(:min_payment => row.min_payment)
      @payment.push(:actual_payment => row.actual_payment)
      @payment.push(:apr => (row.rate)/1200)
      @payment.push(:totalInterest => 0)
      @payment.push(:paymentCount => 0)
      @payment.push(:first_pay => 0)
      @payment.push(:first_int => 0)
      @payment.push(:next_pay => 0)
      @payment.push(:next_int => 0)
      @payment.push(:new_balance => 0)
      @actual_payment.push(@payment)
    end
    
    @myActualInterestPaid = 0
    @myAdvantageInterestPaid = 0
    @myActualMonths = 1
    @myAdvantageMonths = 1
    @loopMaxHit = false
    @thisMonthInterest = 0
    @thisMonthPrincipal = 0
    @myAdvancePayment = @actual_payment;
    begin
      @contActual = false;
      @contAdvantage = false;
      @monthlyPayments = @total_payment
      x = 0
      while x < @actual_payment.count 
        @rw = @actual_payment[x]
        #abort((@rw[1][:balance]).inspect)
        if (@rw[1][:balance] > 0.0001) 
          @rw[7][:paymentCount] += 1
          @interest = (@rw[1][:balance] * @rw[5][:apr]).round(2)
          @myActualInterestPaid += @interest
          @rw[1][:balance] += @interest
          @rw[6][:totalInterest] += @interest
          @topay = [@rw[1][:balance], [@rw[4][:actual_payment], @rw[3][:min_payment]].max].min
          @rw[1][:balance] -= @topay
          @monthlyPayments -= @topay
          if (@rw[1][:balance] > 0.0001)
            @contActual = true;
          end
            if(@interest > @rw[4][:actual_payment])
              @accountsHaveErrors = true;
            end         
        end
        @myActualPayments[x] = @rw;
          x += 1
      end
      #advance payment
      @monthlyPayments = @total_payment
      @firstMonthInterest = 0
      @firstMonthPrincipal = 0
      x = 0
      while x < @myAdvancePayment.count
        @rw = @myAdvancePayment[x]
        if @rw[1][:balance] > 0.0001
          @rw[7][:paymentCount] += 1
          @interest = (@rw[1][:balance] * @rw[5][:apr]).round(2)
          @myAdvantageInterestPaid += @interest
          @rw[1][:balance] += @interest
          @rw[6][:totalInterest] += @interest
          @topay = [@rw[1][:balance], @rw[3][:min_payment]].min
          @rw[1][:balance] -= @topay
          @monthlyPayments -= @topay
          if (@rw[1][:balance] > 0.0001)
            @contAdvantage = true;
          end
          if (@myAdvantageMonths == 1)
            @rw[8][:first_pay] = @topay;
            @rw[9][:first_int] = @interest
            @firstMonthInterest += @interest
            @firstMonthPrincipal += ( @topay - @interest );
            @rw[12][:new_balance] = @rw[1][:balance]
          elsif @myAdvantageMonths == 2
            @rw[10][:next_pay] = @topay
            @rw[11][:next_int] = @interest
          end
        elsif @myAdvantageMonths == 1
          @rw[8][:first_pay] = 0
          @rw[9][:first_int] = 0
          @rw[12][:new_balance] = 0
        elsif @myAdvantageMonths == 2
          @rw[10][:next_pay] = 0
          @rw[11][:next_int] = 0
        end
        @myAdvancePayment[x] = @rw
        x += 1
      end
      #abort(@contAdvantage.inspect)
      x -= 1
      while (x > -1 && @monthlyPayments > 1 && @contAdvantage)
        @rw = @myAdvancePayment[x]
        if (@rw[1][:balance] > 0.0001)
          @topay = [@rw[1][:balance], @monthlyPayments].min
          @rw[1][:balance] -= @topay;
          @monthlyPayments -= @topay;
          if @myAdvantageMonths == 1
            @rw[8][:first_pay] += @topay;
            @firstMonthPrincipal += @topay;
            @rw[12][:new_balance] = @rw[1][:balance]
          elsif @myAdvantageMonths == 2
            @rw[10][:next_pay] += @topay;
          end
#          if @rw[1][:balance] < 0.0001 
#            if $row['next_send'] === null
#              $rw['final_payment_desc'] = date("F, Y", mktime(0, 0, 0, date("m") + $myAdvantageMonths));
#              $rw['final_payment'] = date("Y-m-d", mktime(0, 0, 0, date("m") + $myAdvantageMonths));
#
#              if $rw['final_payment'] > $debtFreeDate
#                $debtFreeDate = $rw['final_payment'];
#                $debtFreeDateDesc = $rw['final_payment_desc'];
#              end
#            end
#          end
        end
        @myAdvancePayment[x] = @rw;

            x -= 1
      end
      if @monthlyPayments > 0.0001
            @contAdvantage = false;
      end
        if @contActual
            @myActualMonths += 1
        end
        if @contAdvantage
            @myAdvantageMonths += 1
        end    
    end while @contActual || @contAdvantage
  end
  
  def actualPayment
    @total_account = totalPayment
    @totalBalance = @total_account[0]
    @totalPayments = @total_account[1]
    @totalMinimum = @total_account[2];
    @totalOriginalBalance = @total_account[3]
    @accountsHaveErrors = false;
    @financial_account = current_user.financial_accounts
    @myActualPayments = nil
    @myAdvantagePayments = nil
    @myActual_Payments = Array.new
    @actual_payment = Array.new
    @financial_account.each do |row|
      x = 0
      @payment = Array.new
      @payment.push(:company_name => row.company_name)
      @payment.push(:balance => row.balance)
      @payment.push(:original_balance => row.original_balance)
      @payment.push(:min_payment => row.min_payment)
      @payment.push(:actual_payment => row.actual_payment)
      @payment.push(:apr => (row.rate)/1200)
      @payment.push(:totalInterest => 0)
      @payment.push(:paymentCount => 0)
      @payment.push(:first_pay => 0)
      @payment.push(:first_int => 0)
      @payment.push(:next_pay => 0)
      @payment.push(:next_int => 0)
      @payment.push(:new_balance => 0)
      @myActual_Payments.push(@payment)
    end
    
    @myActualInterestPaid = 0
    @myActualMonths = 1
    @loopMaxHit = false
    @thisMonthInterest = 0
    @thisMonthPrincipal = 0
    @myActualPayments = @myActual_Payments
    @myAdvantagePayments = @myActual_Payments
    begin
      @contActual = 0
      @monthlyPayments = @totalPayments
      x = 0
      while (x < @myActualPayments.count) 
            @rw = @myActualPayments[x]
            if (@rw[1][:balance] > 0.0001) 
              @rw[7][:paymentCount] += 1
              @interest = (@rw[1][:balance] * @rw[5][:apr]).round(2)
              @myActualInterestPaid += @interest
              @rw[1][:balance] += @interest
              @rw[6][:totalInterest] += @interest
              @topay = [@rw[1][:balance], [@rw[4][:actual_payment], @rw[3][:min_payment]].max].min
              @rw[1][:balance] -= @topay
              @monthlyPayments -= @topay
              if (@rw[1][:balance] > 0.0001)
                    @contActual = 1
              end
                if(@interest > @rw[4][:actual_payment])
                    @accountsHaveErrors = true
                end

            end
            @myActualPayments[x] = @rw
            x += 1
      end
         if (@monthlyPayments > 0.0001)
           @contAdvantage = false
         end
         if (@contActual)
           @myActualMonths += 1
         end
        
    end while (@contActual == 1)
    abort(@myActual_Payments.inspect)
    @myAdvantageInterestPaid = 0
    @myAdvantageMonths = 1
    @loopMaxHit = false
    @thisMonthInterest = 0
    @thisMonthPrincipal = 0
    begin
      @contAdvantage = 0;
      @monthlyPayments = @totalPayments;
      @firstMonthInterest = 0
      @firstMonthPrincipal = 0
        y = 0
        abort(@myAdvantagePayments.inspect)
         while (y < @myAdvantagePayments.count) 
           @tw = @myAdvantagePayments[y]
            if (@tw[1][:balance] > 0.0001)
              abort('hello')
                @tw[7][:paymentCount] += 1
                @interest = (@tw[1][:balance] * @tw[5][:apr]).round(2)
                @myAdvantageInterestPaid += @interest
                @tw[1][:balance] += @interest
                @tw[6][:totalInterest] += @interest
                @topay = [@tw[1][:balance], @tw[3][:min_payment]].min
                @tw[1][:balance] -= @topay
                @monthlyPayments -= @topay
                if (@tw[1][:balance] > 0.0001)
                    @contAdvantage = 1
                end
                
                if (@myAdvantageMonths == 1)
                  @tw[8][:first_pay] = @topay;
                    @tw[9][:first_int] = @interest
                    @firstMonthInterest = @firstMonthInterest + @interest
                    @firstMonthPrincipal = @firstMonthPrincipal + ( @topay - @interest )
                    @tw[12][:new_balance] = @tw[1][:balance]
                elsif(@myAdvantageMonths == 2)
                    @tw[8][:first_pay] = 0
                    @tw[9][:first_int] = 0
                end
            elsif (@myAdvantageMonths == 1)
               @tw[8][:first_pay] = @topay
               @tw[9][:first_int] = @interest
               @tw[12][:new_balance] = 0
            else
                @tw[10][:next_pay] = 0
                @tw[11][:next_int] = 0
            end
            @myAdvantagePayments[y] = @tw

            y = y + 1
         end
         
         y = y-1
         while (y > -1 && @monthlyPayments > 1 && @contAdvantage)
            @tw = @myAdvantagePayments[y]
             if (@tw[1][:balance] > 0.0001)
               @topay = [@tw[1][:balance], @monthlyPayments].min
                @tw[1][:balance] -= @topay
                @monthlyPayments -= @topay
                
                if (@myAdvantageMonths == 1) 
                    @tw[8][:first_pay] += @topay
                    @firstMonthPrincipal += @topay
                    @tw[12][:new_balance] = @tw[1][:balance]
                else
                  @tw[10][:next_pay] += @topay
                end
             end
             @myAdvantagePayments[y] = @tw
             y = y-1
         end
         if (@monthlyPayments > 0.0001)
           @contAdvantage = 0
         end
         if (@contAdvantage)
           @myAdvantageMonths += 1
         end
        
    end while (@contAdvantage == 1)
    
    abort(@myAdvantagePayments.inspect)
  end
  
end

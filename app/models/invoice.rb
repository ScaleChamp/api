class Invoice < ApplicationRecord
  enum state: {
      draft: 0,
      paid: 1,
      pending: 2,
      failure: 3
  }

  belongs_to :project

  <<-SQL
    INSERT INTO invoices(project_id, total, credit_applied, items)
    select project_id,
          total_usages.total,
           0 as credit_applied,
          total_usages.items
    from (select project_id,
                coalesce(sum(ceil(extract(epoch from (
                        CASE WHEN ended_at BETWEEN previous_payout and current_payout THEN ended_at ELSE current_payout END
                        - CASE
                              WHEN started_at BETWEEN previous_payout and current_payout THEN started_at
                              ELSE previous_payout END)) / 3600) * plans.price), 0)          as total,
                credit,
                json_agg(json_build_object(
                        'id', usages.instance_id,
                        'plan', plans.name,
                        'start', CASE WHEN started_at BETWEEN previous_payout and current_payout THEN started_at ELSE previous_payout END,
                        'end', CASE WHEN ended_at BETWEEN previous_payout and current_payout THEN ended_at ELSE current_payout END,
                        'hours', ceil(extract(epoch from (
                                CASE
                                    WHEN ended_at BETWEEN previous_payout and current_payout THEN ended_at
                                    ELSE current_payout END
                                - CASE
                                      WHEN started_at BETWEEN previous_payout and current_payout THEN started_at
                                      ELSE previous_payout END)) / 3600),
                        'price', ceil(extract(epoch from (
                                CASE
                                    WHEN ended_at BETWEEN previous_payout and current_payout THEN ended_at
                                    ELSE current_payout END
                                - CASE
                                      WHEN started_at BETWEEN previous_payout and current_payout THEN started_at
                                      ELSE previous_payout END)) / 3600) * plans.price)) as items
         from usages
                  left join plans on plans.id = usages.plan_id
                  left join projects on projects.id = usages.project_id
                  left join (select date_trunc('month', current_timestamp ) :: TIMESTAMP as previous_payout,
                                    date_trunc('month', current_timestamp + interval '1 month')                                   as current_payout) as payouts
                            on true
         where (ended_at is null or ended_at >= previous_payout) and (started_at < current_payout)
         group by project_id, credit) as total_usages;
  SQL
end

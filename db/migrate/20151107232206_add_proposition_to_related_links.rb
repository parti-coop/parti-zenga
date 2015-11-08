class AddPropositionToRelatedLinks < ActiveRecord::Migration
  def change
    add_reference :related_links, :proposition, index: true

    reversible do |dir|
      dir.up do
        Issue.all.each do |issue|
          issue.comments.each do |comment|
            if comment.proposition.present?
              comment.related_links.each do |related_link|
                related_link.proposition = comment.proposition
                related_link.save!
              end
            end
          end

          issue.statuses.each do |status|
            status.replies.each do |reply|
              reply.related_links.each do |related_link|
                related_link.proposition = reply.status.source.stated_proposition
                related_link.save!
              end
            end
          end

          issue.propositions.each do |proposition|
            proposition.stands.each do |stand|
              stand.related_links.each do |related_link|
                related_link.proposition = stand.proposition
                related_link.save!
              end
            end
          end
        end
      end
    end
  end
end

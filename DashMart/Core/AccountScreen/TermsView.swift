//
//  TermsView.swift
//  DashMart
//
//  Created by Victor on 18.04.2024.
//

import SwiftUI

struct TermsView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                    Text("""
                     Buyer Protection Money Back Guarantee” or “Basic Buyer Protection” Rules, Terms & Conditions (the “Official Rules”)
                     
                     These Terms & Conditions apply to the “Buyer Protection Money Back Guarantee” or “Basic Buyer Protection” in AliExpress (the “Buyer Protection”).
                     
                     1. Promoter: the contracting party determined in accordance with the section “1.1 Contracting Party” of the Alibaba.com Transaction Services Agreement (“AliExpress” or the “Promoter”).
                     
                     2. Eligible Member: You must be a registered member of AliExpress with a valid account and have successfully made and completed a purchase of goods and/or services on AliExpress.
                     
                     3. Buyer Protection Period: the number of days (appearing/confirmed on the product listing page at the time when the Eligible Member completed the purchase from the seller on AliExpress) which the seller guarantees the Eligible Member that it would receive the goods and/or services ordered from the seller, start counting from the day the Eligible Member completes such purchase on AliExpress.
                     
                     4. Rules:
                     a. If the Eligible Member does not receive the goods and/or services within Buyer Protection Period or receives goods and/or services that are sub-standard in its view, the Eligible Member may initiate the dispute procedures as stipulated in AliExpress under “Disputes and Reports” to report this incident (“Dispute Procedures”) to AliExpress.
                     
                     b. During the Dispute Procedures, AliExpress will investigate this incident considering (but not limited to) the following factors:
                     
                     i. Whether goods and/or services received by the Eligible Member are damaged, defective, or are substantially different from what has been presented or described on the product listing page;
                     ii. Whether the non-arrival of goods and/or services to the Eligible Member is due to factors beyond its control;
                     iii. Whether the non-arrival of goods and/or services to the Eligible Member is due to error or miscommunication on the part of the Eligible Member (eg providing incorrect shipping address etc); or
                     iv. Whether the goods and/or services are returned to the seller due to such goods and/or services not being able to clear customs.
                     
                     c. AliExpress may ask the Eligible Member for relevant information, documentation, records and/or other evidence to support Eligible Member’s claim.
                     
                     d. After the Dispute Procedures, AliExpress will make a determination (which is final and not subject to appeal). If the determination is in favor of the Eligible Member, subject to the terms of the Official Rules (including but not limited to the force majeure clause below), the Eligible Member will be eligible for a refund within 15 days after the completion of the Dispute Procedures. Such refund will be generally credited to the same means of payment used by the Eligible Member when placing the affected order on AliExpress, unless the parties have agreed on some other means and subject to the relevant technical constraints.
                     
                     5. General Rules:
                     a. By participating in this Buyer Protection, you agree to be bound by these Official Rules.
                     
                     b. Any fraud and/or abuse by you (as determined by the Promoter at its sole discretion) will result in forfeiture of your eligibility to this Buyer Protection and/or rights under these Official Rules.
                     
                     c. AliExpress is not responsible for any late, lost, delayed, incomplete, illegible, misdirected or undeliverable entries, responses, or other correspondence, whether by e-mail or otherwise.
                     
                     d. The eligibility to this Buyer Protection shall be determined by AliExpress at their sole discretion based on the Promoter’s record. If there is any discrepancy between the record of transaction held by you and that held by the Promoter, the Promoter’s record shall be conclusive and binding on you.
                     
                     e. AliExpress reserves the right to amend these Official Rules without prior notice. In the event of disputes, the decision of the Promoter shall be final and binding.
                     
                     f. AliExpress reserves the right and absolute discretion to cancel or revoke anyone’s right to participate in this Buyer Protection.
                     
                     6. Force Majeure: Under no circumstances shall AliExpress be held liable to the Eligible Member for this Buyer Protection or any rights under these Official Rules due to or resulting directly or indirectly from acts of nature, forces or causes beyond the reasonable control of AliExpress or the relevant seller, including without limitation, Internet failures, computer, telecommunications or any other equipment failures, electrical power failures, strikes, labor disputes, riots, insurrections, civil disturbances, shortages of labor or materials, fires, flood, storms, explosions, acts of God, war, governmental actions, orders of domestic or foreign courts or tribunals, or non-performance of third parties or any suspension or disruption of transportation or business operation (including but not limited to delays or disruption of the resumption of work or operation ordered by any government agency) in the event of a national or regional spread of epidemic or pandemic.
                     
                     7. Conflict of Terms and Conditions:
                     a. In case of any discrepancy in the content between the English and other non-English language versions of these Official Rules, the English version shall prevail.
                     
                     b. In the event that any of the terms under these Official Rules conflict with rules and/or any such related information displayed elsewhere on AliExpress, the terms under these Official Rules shall prevail. The Alibaba.com Transaction Services Agreement shall prevail and complement these Rules.
                     
                     8. Disclaimer: TO THE MAXIMUM EXTENT PERMITTED BY LAW, IN NO EVENT WILL THE PROMOTER BE LIABLE TO YOU FOR ANY DIRECT, INDIRECT, SPECIAL, INCIDENTAL, EXEMPLARY, PUNITIVE OR CONSEQUENTIAL DAMAGES (INCLUDING LOSS OF USE, DATA, BUSINESS OR PROFITS) ARISING OUT OF OR IN CONNECTION WITH YOUR PARTICIPATION IN THIS BUYER PROTECTION, WHETHER SUCH LIABILITY ARISES FROM ANY CLAIM BASED UPON CONTRACT, WARRANTY, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, AND WHETHER OR NOT SPONSOR HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH LOSS OR DAMAGE.
                     
                     9. Disputes: You acknowledge and agree that the Promoter or any of its affiliates shall not be responsible, and shall have no liability to the Eligible Member or anyone else for any dispute or claim that arises out of your participation in this Buyer Protection.
                     """)
                .font(.system(size: 14))
                .padding(.horizontal, .s16)
            }
            .navigationTitle("Terms and Conditions")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

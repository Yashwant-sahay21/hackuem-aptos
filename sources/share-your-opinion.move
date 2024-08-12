module share_your_opinion_address::share_opinion {
    use aptos_framework::aptos_account;
    use aptos_framework::event;
    use aptos_framework::signer;
    use std::string::{utf8, String};
    use aptos_std::table::{Self, Table};

    struct Opinion has key {
        opinion_id: u64,
        message: String,
    }

    struct OpinionBook has key {
        feedbacks: Table<u64, Opinion>,
    }

    struct OpinionCount has key, store {
        count: u64,
    }
    public entry fun isAdmin(addr:address){
        assert!(addr == @share_your_opinion_address, 5);
    }
    
    public entry fun initialize_account(account:&signer, msg:String) {
        let account_address = signer::address_of(account);
        isAdmin(account_address);
        if (!exists<Opinion>(account_address)) {
            let fb = Opinion{
                opinion_id:0,
                message: msg,
            };
            move_to(account, fb);
        };
        if (!exists<OpinionCount>(account_address)) {
            let fb_counter = OpinionCount{
                count:0
            };
            move_to(account, fb_counter);
        };
    }

    public fun send_feedback(account: &signer, feedback_msg: String) acquires OpinionCount, Opinion  {
        let account_address = signer::address_of(account);
        assert!(exists<OpinionCount>(account_address), 0); // Ensure OpinionCount exists
        let fb_count = borrow_global_mut<OpinionCount>(account_address);
        let fb_body = borrow_global_mut<Opinion>(account_address);

        fb_count.count = fb_count.count + 1;

        fb_body.opinion_id = fb_count.count;

        fb_body.message = feedback_msg;

        // let feedback = Opinion {
        //     opinion_id: fb_count,
        //     message: feedback_msg,
        // };

        // let feedback_book = borrow_global_mut<OpinionBook>(&account_address);
        // table::add(&mut feedback_book.feedbacks, fb_count, feedback);

        // borrow_global_mut<OpinionCount>(&account_address).count = fb_count;
    }

    // public fun fetch_feedback(account: &signer): String acquires Opinion {
    //     let account_address = signer::address_of(account);
    //     assert!(exists<OpinionBook>(account_address), 0); // Ensure OpinionBook exists
    //     let feedback_book = borrow_global<Opinion>(account_address);
    //     feedback_book.message
    //     table::borrow(&feedback_book.feedbacks, opinion_id)
    // }
}

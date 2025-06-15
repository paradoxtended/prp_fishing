import { type Context, createContext, useContext, useState } from 'react';
import { useNuiEvent } from '../hooks/useNuiEvent';
import { debugData } from '../utils/debugData';

debugData([
    {
        action: 'loadLocales',
        data: ['en', 'fr', 'de', 'it', 'es', 'pt-BR', 'pl', 'ru', 'ko', 'zh-TW', 'ja', 'es-MX', 'zh-CN'],
    },
]);

debugData([
    {
        action: 'setLocale',
        data: {
            language: 'English',
            ui: {
                welcome: 'Welcome',
                statistics: 'Statistics',
                statistics_description: 'This page shows you your current fishing statistics such as total earned, how many fishes you caught and more.',
                leaderboard: 'Leaderboard',
                leaderboard_description: 'Here you can find all fishermen. Check who\'s the best fisherman of this city.',
                ongoing_challenges: 'Ongoing daily challenges',
                claim: 'Claim',
                claimed: 'Claimed',
                reload: 'Reload',
                total_caught: 'Total number of fish caught',
                total_caught_description: 'Total number of fish that you\'ve caught.',
                total_earned: 'Total earned',
                total_earned_description: 'Total money earned from the moment you started fishing.',
                longest_fish: 'Longest fish ever caught',
                longest_fish_description: 'The longest fish you\'ve ever caught at your fishing journey.',
                lb_username: 'Name',
                lb_fish_caught: 'Fish caught',
                lb_total_earned: 'Earned so far',
                lb_longest_fish: 'Longest fish caught',
                lb_placeholder: 'Look up yourself...',
                shop: 'Shop',
                shop_description: 'Here you can buy some fishing equipment to your fishing journey.',
                shopping_cart: 'Shopping Cart',
                fishing_equipment: 'Fishing Equipment',
                total_cost: 'Total Cost',
                pay_bank: 'Pay Bank',
                pay_money: 'Pay Cash',
                empty_cart: 'Drag shop items here',
                sell: 'Sell',
                sell_description: 'Here you can sell all your fishes. Keep up the good work mate.',
                sell_inventory: 'Sell Inventory',
                sell_fishes: 'Sell Fishes',
                no_fishes: 'You have nothing to sell, bring me some fishes.',
                sell_get_paid: 'Get Paid',
                rent_boat: 'Rent a boat',
                rent_boat_description: 'This page has been made for renting. Here you can rent any of these boats.',
                price: 'Price'
            },
        },
    },
]);

interface Locale {
    language: string;
    ui: {
        welcome: string;
        statistics: string;
        statistics_description: string;
        leaderboard: string;
        leaderboard_description: string;
        ongoing_challenges: string;
        catch_specified_fish: string;
        catch_specified_fish_description: string;
        catch_amount_of_fishes: string;
        catch_amount_of_fishes_description: string;
        claim: string;
        claimed: string;
        reload: string;
        total_caught: string;
        total_caught_description: string;
        total_earned: string;
        total_earned_description: string;
        longest_fish: string;
        longest_fish_description: string;
        lb_username: string;
        lb_fish_caught: string;
        lb_total_earned: string;
        lb_longest_fish: string;
        lb_placeholder: string;
        shop: string;
        shop_description: string;
        shopping_cart: string;
        fishing_equipment: string;
        total_cost: string;
        pay_bank: string;
        pay_money: string;
        empty_cart: string;
        sell: string;
        sell_description: string;
        sell_fishes: string;
        no_fishes: string;
        sell_inventory: string;
        sell_get_paid: string;
        rent_boat: string;
        rent_boat_description: string;
        price: string;
    };
}

interface LocaleContextValue {
    locale: Locale;
    setLocale: (locales: Locale) => void;
}

const LocaleCtx = createContext<LocaleContextValue | null>(null);

const LocaleProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
    const [locale, setLocale] = useState<Locale>({
        language: '',
        ui: {
            welcome: '',
            statistics: '',
            statistics_description: '',
            leaderboard: '',
            leaderboard_description: '',
            ongoing_challenges: '',
            catch_amount_of_fishes: '',
            catch_specified_fish_description: '',
            catch_specified_fish: '',
            catch_amount_of_fishes_description: '',
            claim: '',
            claimed: '',
            reload: '',
            total_caught: '',
            total_caught_description: '',
            total_earned: '',
            total_earned_description: '',
            longest_fish: '',
            longest_fish_description: '',
            lb_username: '',
            lb_fish_caught: '',
            lb_total_earned: '',
            lb_longest_fish: '',
            lb_placeholder: '',
            shop: '',
            shop_description: '',
            shopping_cart: '',
            fishing_equipment: '',
            total_cost: '',
            pay_bank: '',
            pay_money: '',
            empty_cart: '',
            sell: '',
            sell_description: '',
            sell_fishes: '',
            no_fishes: '',
            sell_inventory: '',
            sell_get_paid: '',
            rent_boat: '',
            rent_boat_description: '',
            price: ''
        },
    });

    useNuiEvent('setLocale', async (data: Locale) => setLocale(data));

    return <LocaleCtx.Provider value={{ locale, setLocale }}>{children}</LocaleCtx.Provider>;
};

export default LocaleProvider;

export const useLocales = () => useContext<LocaleContextValue>(LocaleCtx as Context<LocaleContextValue>);
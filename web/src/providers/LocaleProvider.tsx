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
                lb_placeholder: 'Look up yourself...'
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
            lb_placeholder: ''
        },
    });

    useNuiEvent('setLocale', async (data: Locale) => setLocale(data));

    return <LocaleCtx.Provider value={{ locale, setLocale }}>{children}</LocaleCtx.Provider>;
};

export default LocaleProvider;

export const useLocales = () => useContext<LocaleContextValue>(LocaleCtx as Context<LocaleContextValue>);
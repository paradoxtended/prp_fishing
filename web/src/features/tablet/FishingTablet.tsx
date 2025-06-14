import React from "react";
import { useNuiEvent } from "../../hooks/useNuiEvent";
import './index.css'
import MainPage from "./components/MainPage";
import StatsPage from "./components/StatsPage";
import { fetchNui } from "../../utils/fetchNui";
import Leaderboard from './components/Leaderboard';
import type { LeaderboardProps, ShopProps, StatsProps } from "../../typings/tablet";
import ShopWrapper from "./components/shop/ShopWrapper";
import Sell from "./components/sell/Sell";

const FishingTablet: React.FC = () => {
    const [visible, setVisible] = React.useState<boolean>(false);
    const [shouldLoad, setShouldLoad] = React.useState<boolean>(true);
    const [currentPage, setCurrentPage] = React.useState<string | null>('home');
    const [leaderboard, setLeaderboard] = React.useState<LeaderboardProps[]>([]);
    const [statistics, setStatistics] = React.useState<StatsProps>({
        earned: 0,
        fishCaught: 0,
        longestFish: 0
    });
    const [shopItems, setShopItems] = React.useState<ShopProps[]>([]);

    const handleClose = () => {
        const container = document.querySelector('.container') as HTMLDivElement;
        if (container === null) return;

        container.style.animation = 'fadeOut 300ms forwards';
        setTimeout(() => setVisible(false), 300);
        fetchNui('closeTablet');
    };

    React.useEffect(() => {
        if (!visible) return;

        const keyHandler = (e: KeyboardEvent) => {
            if (['Escape'].includes(e.code)) handleClose();
        };

        window.addEventListener('keydown', keyHandler);

        return () => window.removeEventListener('keydown', keyHandler);
    }, [visible]);

    useNuiEvent('openTablet', (data) => {
        setCurrentPage('home');
        setShouldLoad(true);
        setVisible(true);
        setLeaderboard(data.leaderboard);
        setStatistics(data.statistics);
        setShopItems(data.shop);

        setTimeout(() => setShouldLoad(false), 1);
    });

    return (
        visible && (
            <div className="container">
                <div className="header">
                    <div className="left-section">
                        <p className="time">7:08 PM</p>
                        <i className="fa-solid fa-house" onClick={() => { if (currentPage !== 'home') setCurrentPage('home') }}></i>
                    </div>
                    <div className="right-section">
                        <i className="fa-solid fa-circle-info"></i>
                        <i className="fa-solid fa-wifi"></i>
                    </div>
                </div>
                <div className="main-tablet">
                    {currentPage === 'home' && <MainPage setPage={setCurrentPage} loading={shouldLoad} />}
                    {currentPage === 'stats' && <StatsPage stats={statistics} />}
                    {currentPage === 'leaderboard' && <Leaderboard leaderboard={leaderboard} />}
                    {currentPage === 'shop' && <ShopWrapper items={shopItems} />}
                    {currentPage === 'sell' && <Sell />}
                </div>
            </div>
        )
    );
};

export default FishingTablet
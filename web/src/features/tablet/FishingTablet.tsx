import React from "react";
import { useNuiEvent } from "../../hooks/useNuiEvent";
import './FishingTablet.css'
import MainPage from "./MainPage";
import StatsPage from "./StatsPage";
import { fetchNui } from "../../utils/fetchNui";

const FishingTablet: React.FC = () => {
    const [visible, setVisible] = React.useState<boolean>(false);
    const [shouldLoad, setShouldLoad] = React.useState<boolean>(true);
    const [currentPage, setCurrentPage] = React.useState<string | null>('home');

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

    useNuiEvent('openTablet', () => {
        setCurrentPage('home');
        setShouldLoad(true);
        setVisible(true);
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
                <div className="main">
                    {currentPage === 'home' && <MainPage setPage={setCurrentPage} loading={shouldLoad} />}
                    {currentPage === 'stats' && <StatsPage />}
                </div>
            </div>
        )
    );
};

export default FishingTablet
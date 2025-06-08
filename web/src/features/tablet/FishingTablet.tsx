import React from "react";
import type { TabletProps } from "../../typings/tablet";
import { useNuiEvent } from "../../hooks/useNuiEvent";
import './FishingTablet.css'
import MainPage from "./MainPage";

const FishingTablet: React.FC = () => {
    const [visible, setVisible] = React.useState(false);
    const [currentPage, setCurrentPage] = React.useState('home');
    const [stats, setStats] = React.useState<TabletProps>({
        myStats: {
            fishesCaught: null
        }
    });

    const handleClose = () => {
        const container = document.querySelector('.container') as HTMLDivElement;
        if (container === null) return;

        container.style.animation = 'fadeOut 300ms forwards';
        setTimeout(() => setVisible(false), 300)
    };

    React.useEffect(() => {
        if (!visible) return;

        const keyHandler = (e: KeyboardEvent) => {
            if (['Escape'].includes(e.code)) handleClose();
        };

        window.addEventListener('keydown', keyHandler);

        return () => window.removeEventListener('keydown', keyHandler);
    }, [visible]);

    useNuiEvent<TabletProps>('openTablet', (data) => {
        setStats(data);
        setVisible(true);
    });

    return (
        visible && (
            <div className="container">
                <div className="header">
                    <div className="left-section">
                        <p className="time">7:08 PM</p>
                        <i className="fa-solid fa-house" onClick={() => setCurrentPage('home')}></i>
                    </div>
                    <div className="right-section">
                        <i className="fa-solid fa-circle-info"></i>
                        <i className="fa-solid fa-wifi"></i>
                    </div>
                </div>
                <div className="main">
                    {currentPage === 'home' && <MainPage />}
                </div>
            </div>
        )
    );
};

export default FishingTablet
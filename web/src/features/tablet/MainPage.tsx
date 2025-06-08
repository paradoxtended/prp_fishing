import React from "react";
import { useLocales } from "../../providers/LocaleProvider";

const MainPage: React.FC = () => {
    const { locale } = useLocales();

    return (
        <div className="main-page">
            <p className="welcome">{locale.ui.welcome}</p>
            <p className="username">Ravage</p>

            <div className="cards">
                <div className="card">
                    
                </div>
            </div>
        </div>
    )
};

export default MainPage
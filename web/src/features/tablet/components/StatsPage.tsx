import React from "react";
import Loader from "./Loader";
import { useLocales } from "../../../providers/LocaleProvider";
import type { StatsProps } from "../../../typings/tablet";

type StatsPageProps = {
    stats: StatsProps
}

const StatsPage: React.FC<StatsPageProps> = ({ stats }) => {
    const [visible, setVisible] = React.useState<boolean>(false);
    const { locale } = useLocales();

    React.useEffect(() => {
        if (visible) return;
        setTimeout(() => setVisible(true), 500);
    }, [visible]);

    return (
        visible ? (
            <div className="stats-page">
                <p className="title-page">{locale.ui.statistics}</p>
                <p className="description-page">{locale.ui.statistics_description}</p>
                <div className="main-section">
                    <div className="card">
                        <p className="title"><i className="fa-solid fa-fish-fins"></i> {locale.ui.total_caught}</p>
                        <p className="value">{stats.fishCaught}</p>
                        <p className="description">{locale.ui.total_caught_description}</p>
                    </div>
                    <div className="card">
                        <p className="title"><i className="fa-solid fa-dollar-sign"></i> {locale.ui.total_earned}</p>
                        <p className="value">${stats.earned.toLocaleString('en-US', { minimumFractionDigits: 2 })}</p>
                        <p className="description">{locale.ui.total_earned_description}</p>
                    </div>
                    <div className="card">
                        <p className="title"><i className="fa-solid fa-ruler"></i> {locale.ui.longest_fish}</p>
                        <p className="value">{stats.longestFish} inches</p>
                        <p className="description">{locale.ui.longest_fish_description}</p>
                    </div>
                </div>
            </div>
        ) : <Loader />
    )
};

export default StatsPage
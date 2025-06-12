import { useEffect, useState } from "react";
import Loader from "../Loader";
import type { SellProps } from "../../../../typings/tablet";
import { useLocales } from "../../../../providers/LocaleProvider";
import InventoryGrid from "./InventoryGrid";

type Properties = {
    items: SellProps[]
};

const Sell: React.FC<Properties> = ({ items }) => {
    const { locale } = useLocales();
    const [visible, setVisible] = useState(false);
    const [inventory, setInventory] = useState<SellProps[]>(() => {
        const initial = new Array(16).fill(null);
        items.forEach((item, i) => initial[i] = item);
        return initial;
    });

    useEffect(() => {
        if (visible) return;
        setTimeout(() => setVisible(true), 500);
    }, [visible]);

    // todo create a selling page where player can insert the fishes into the selling container containing 16 slots (4x4) :eyes:
    return (
        visible ? (
            <div className="sell-page">
                <p className="sell-title">{locale.ui.sell}</p>
                <p className="sell-description">{locale.ui.sell_description}</p>
                <section>
                    <div className="leftInventory">
                        <p className="title">{locale.ui.sell_fishes}</p>
                        <InventoryGrid items={inventory} setItems={setInventory} />
                    </div>
                </section>
            </div>
        ) : <Loader />
    )
};

export default Sell
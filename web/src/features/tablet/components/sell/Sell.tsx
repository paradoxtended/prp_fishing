import { useEffect, useState } from "react";
import Loader from "../Loader";
import type { SellProps } from "../../../../typings/tablet";
import { useLocales } from "../../../../providers/LocaleProvider";
import InventoryGrid from "./InventoryGrid";
import React from "react";
import { fetchNui } from "../../../../utils/fetchNui";

const getTotalCost = (cart: (SellProps | null)[]): number => {
    return cart.reduce((total, item) => {
        if (!item) return total;
        return total + item.price * item.length
    }, 0);
};
 
const Sell: React.FC = () => {
    const [animatedTotal, setAnimatedTotal] = React.useState(0);
    const { locale } = useLocales();
    const [visible, setVisible] = useState(false);
    const [inventory, setInventory] = useState<{
        inv: (SellProps | null)[];
        cart: (SellProps | null)[];
    }>({ inv: [], cart: [] });

    async function getSellableItems() {
        const data: SellProps[] = await fetchNui('getSellableFishes');
        setInventory(() => {
            const initInv = new Array(16).fill(null); // 16 slots in inv
            const initCart = new Array(8).fill(null); // 8 slots in selling part
            
            data.forEach((item, i) => {
                if (i < 16) initInv[i] = item;
                else if (i < 24) initCart[i - 16] = item;
            });

            return { inv: initInv, cart: initCart };
        });
    };

    useEffect(() => {
        if (visible) return;

        getSellableItems();

        setTimeout(() => setVisible(true), 500);
    }, [visible]);
    
    React.useEffect(() => {
        const end = getTotalCost(inventory.cart);
        const start = animatedTotal;
        const duration = 500;
        let startTime: number | null = null;

        const step = (timestamp: number) => {
            if (!startTime) startTime = timestamp;
            const elapsed = timestamp - startTime;
            const progress = Math.min(elapsed / duration, 1);
            const value = Math.floor(start + (end - start) * easeOutCubic(progress));
            setAnimatedTotal(value);
            if (progress < 1) requestAnimationFrame(step);
        };

        const easeOutCubic = (t: number) => 1 - Math.pow(1 - t, 3);

        requestAnimationFrame(step);
    }, [inventory.cart]);

    async function sell() {
        const success = await fetchNui('sellFishes', inventory.cart);
        
        if (success)
            getSellableItems();
    };

    return (
        visible ? (
            <div className="sell-page">
                <p className="sell-title">{locale.ui.sell}</p>
                <p className="sell-description">{locale.ui.sell_description}</p>
                <section>
                    <div className="leftInventory">
                        <p className="title">{locale.ui.sell_inventory}</p>
                        <InventoryGrid items={inventory.inv} section={'inv'} setInventory={setInventory} />
                    </div>
                    <div className="rightInventory">
                        <p className="title">{locale.ui.sell_fishes}</p>
                        <InventoryGrid items={inventory.cart} section={'cart'} setInventory={setInventory} />
                        <div className="totalCost">
                            <p>{locale.ui.total_cost.toUpperCase()}</p>
                            <span>${animatedTotal.toLocaleString('en-US')}</span>
                        </div>
                        <div className="buttons">
                            <button onClick={async () => sell()}><i className="fa-solid fa-coins"></i>{locale.ui.sell_get_paid}</button>
                        </div>
                    </div>
                </section>
            </div>
        ) : <Loader />
    )
};

export default Sell
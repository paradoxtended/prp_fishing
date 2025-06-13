import React from "react";
// components/CartDropzone.tsx
import { useDrop } from 'react-dnd';
import type { CartProps, SellProps, ShopProps } from "../../../typings/tablet";
import Loader from "./Loader";
import { useLocales } from "../../../providers/LocaleProvider";
import DraggableItem from "./shop/DraggableItem";
import { fetchNui } from "../../../utils/fetchNui";

export const getColor = (rarity: string): { text: string; background: string } => {
  switch (rarity.toLowerCase()) {
    case 'rare': return { text: '#0ea5e9', background: 'radial-gradient(#00000000, #0ea5e920)' };
    case 'epic': return { text: '#db2777', background: 'radial-gradient(#00000000, #be185d25)' };
    case 'legendary': return { text: '#a16207', background: 'radial-gradient(#00000000, #a1620725)' };
    case 'uncommon': return { text: '#84cc16', background: 'radial-gradient(#00000050, #84cc1610)' };
    default: return { text: '#636363', background: 'radial-gradient(#00000050, #31313150)' };
  };
};

type ShopProperties = {
    items: ShopProps[]
};

export const getItemProps = (items: ShopProps[] | SellProps[], itemName: string): ShopProps | SellProps | undefined => {
    return items.find(item => item.label === itemName || item?.name === itemName);
};

const Shop: React.FC<ShopProperties> = ({ items }) => {
    const [visible, setVisible] = React.useState<boolean>(false);
    const { locale } = useLocales();
    const [animatedTotal, setAnimatedTotal] = React.useState(0);
    const [cart, setCart] = React.useState<CartProps[]>([]);

    const [, dropRef] = useDrop(() => ({
        accept: 'ITEM',
        drop: (item: ShopProps) => {
            setCart((prev) => {
                const index = prev.findIndex((i) => i.name === item.name);
                if (index !== -1) {
                    const updated = [...prev];
                    updated[index].count += 1;
                    return updated;
                } else return [...prev, { name: item.name, count: 1 }]
            });
        },
        collect: (monitor) => ({
          isOver: monitor.isOver(),
        }),
    }));

    React.useEffect(() => {
        if (visible) return;
        setTimeout(() => setVisible(true), 500);
    }, [visible]);

    const getTotalCost = () => {
        return cart.reduce((total, cartItem) => {
            const itemData = getItemProps(items, cartItem.name);
            if (!itemData) return total;
            return total + itemData.price * cartItem.count;
        }, 0);
    };

    React.useEffect(() => {
        const end = getTotalCost();
        const start = animatedTotal;
        const duration = 500; // ms
        let startTime: number | null = null;

        const step = (timestamp: number) => {
            if (!startTime) startTime = timestamp;
            const elapsed = timestamp - startTime;
            const progress = Math.min(elapsed / duration, 1);
            const value = Math.floor(start + (end - start) * easeOutCubic(progress));
            setAnimatedTotal(value);
            if (progress < 1) {
                requestAnimationFrame(step);
            }
        };

        const easeOutCubic = (t: number) => 1 - Math.pow(1 - t, 3);

        requestAnimationFrame(step);
    }, [getTotalCost()]);

    const handleBuy = async (type: 'bank' | 'money') => {
        const success = await fetchNui('buyItem', { cart: cart, type: type });

        if (success) setCart([]);
    };  

    return (
        visible ? (
            (
                <div className="shop-page">
                    <p className="shop-title">{locale.ui.shop}</p>
                    <p className="shop-description">{locale.ui.shop_description}</p>
                    <section>
                        <div className="leftInventory">
                            <p className="title">{locale.ui.fishing_equipment}</p>
                            <div className="inv">
                                {items.map((item, index) => {
                                    // Check if item is in inventory..
                                    const inCart = cart.some(cartItem => cartItem.name === item.name);
                                    if (!inCart) {
                                        return (
                                            <DraggableItem key={index} item={item} />
                                        )
                                    };

                                    return <div key={index} className="empty-slot"></div>
                                })}
                            </div>
                        </div>
                        <div className="rightInventory">
                            <p className="title">{locale.ui.shopping_cart}</p>
                            <div className="main"
                            ref={dropRef as unknown as React.Ref<HTMLDivElement>}>
                                {cart.length !== 0 ? (
                                    <div className="cartItems">
                                        {cart.map((item, index) => {
                                            const data = getItemProps(items, item.name);
                                            if (!data) return null;
                                            return (
                                                <div className="item" key={index}>
                                                    <img src={data.imageUrl} />
                                                    <div className="info">
                                                        <p style={{ color: data?.rarity === 'common' ? '#ffffff' : getColor(data.rarity || 'common').text }}>{data.rarity}</p>
                                                        <span>{data.label}</span>
                                                    </div>
                                                    <div className="inputs">
                                                    <button onClick={() => {
                                                        setCart(prev => {
                                                        if (prev[index].count > 1) {
                                                            const updated = [...prev];
                                                            updated[index].count -= 1;
                                                            return updated;
                                                        } else {
                                                            return prev.filter((_, i) => i !== index);
                                                        }
                                                        });
                                                    }}>
                                                        <i className="fa-solid fa-minus"></i>
                                                    </button>
                                                    <input
                                                        type="number"
                                                        value={item.count}
                                                        min={1}
                                                        max={100}
                                                        onChange={(e) => {
                                                        const raw = parseInt(e.target.value || "1", 10);
                                                        const value = Math.max(1, Math.min(100, raw));
                                                        setCart(prev => {
                                                            const updated = [...prev];
                                                            updated[index].count = value;
                                                            return updated;
                                                        });
                                                        }}
                                                    />
                                                    <button onClick={() => {
                                                        setCart(prev => {
                                                        const updated = [...prev];
                                                        if (updated[index].count < 100) {
                                                            updated[index].count += 1;
                                                        }
                                                        return updated;
                                                        });
                                                    }}>
                                                        <i className="fa-solid fa-plus"></i>
                                                    </button>
                                                    </div>
                                                    <p style={{ fontSize: '16px', color: '#c5c5c5', fontFamily: 'Inter', textAlign: 'center', width: '100px' }}>
                                                        ${(data.price * item.count).toLocaleString('en-US')}
                                                    </p>
                                                    <i className="fa-regular fa-trash-can" onClick={() => {
                                                    setCart(prev => prev.filter((_, i) => i !== index));
                                                    }}></i>
                                                </div>
                                            );
                                        })}
                                    </div>
                                ) : (
                                    <div className="empty">
                                        <i className="fa-solid fa-plus-square"></i>
                                        <p>{locale.ui.empty_cart}</p>
                                    </div>
                                )}
                            </div>
                            <div className="totalCost">
                                <p>{locale.ui.total_cost.toUpperCase()}</p>
                                <span>${animatedTotal.toLocaleString('en-US')}</span>
                            </div>
                            <div className="buttons">
                                <button onClick={() => handleBuy('bank')}><i className="fa-solid fa-credit-card"></i>{locale.ui.pay_bank}</button>
                                <button onClick={() => handleBuy('money')}><i className="fa-solid fa-coins"></i>{locale.ui.pay_money}</button>
                            </div>
                        </div>
                    </section>
                </div>
            )
        ) : <Loader />
    )
};

export default Shop
package model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Cart implements Serializable {

    private Map<Integer, CartItem> items = new HashMap<>();

    public Cart() {
    }

    public Map<Integer, CartItem> getItems() {
        return items;
    }

    public void setItems(Map<Integer, CartItem> items) {
        this.items = (items != null) ? items : new HashMap<>();
    }

    /**
     * Them san pham vao gio hang:
     * Neu san pham da co trong gio thi tang so luong; neu chua co thi them moi.
     */
    public void addItem(Product p, int qty) {
        if (p == null || qty <= 0) {
            return;
        }
        int productId = p.getProductId();
        if (items.containsKey(productId)) {
            CartItem existingItem = items.get(productId);
            existingItem.setProduct(p);
            existingItem.setQuantity(existingItem.getQuantity() + qty);
        } else {
            items.put(productId, new CartItem(p, qty));
        }
    }

    /**
     * Cap nhat so luong san pham trong gio:
     * Neu qty <= 0 thi xoa khoi gio, nguoc lai cap nhat so luong moi.
     */
    public void updateQuantity(int productId, int qty) {
        if (!items.containsKey(productId)) {
            return;
        }
        if (qty <= 0) {
            items.remove(productId);
        } else {
            CartItem item = items.get(productId);
            item.setQuantity(qty);
        }
    }

    /**
     * Xoa item khoi gio hang theo productId.
     */
    public void removeItem(int productId) {
        items.remove(productId);
    }

    /**
     * Tinh tong tien cua toan bo gio hang.
     */
    public double getTotalMoney() {
        double total = 0.0;
        for (CartItem item : items.values()) {
            total += item.getTotalPrice();
        }
        return total;
    }

    /**
     * Tinh tong so luong mon do trong gio.
     */
    public int getTotalQuantity() {
        int totalQty = 0;
        for (CartItem item : items.values()) {
            totalQty += item.getQuantity();
        }
        return totalQty;
    }

    /**
     * Tra ve danh sach CartItem de JSP de lap qua.
     */
    public List<CartItem> getItemsList() {
        return new ArrayList<>(items.values());
    }

    public boolean isEmpty() {
        return items.isEmpty();
    }

    public void clear() {
        items.clear();
    }
}

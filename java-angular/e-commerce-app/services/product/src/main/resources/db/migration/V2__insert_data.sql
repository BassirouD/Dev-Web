-- Insérer des catégories dans la table category
INSERT INTO category (id, description, name)
VALUES
    (nextval('category_seq'), 'Électronique grand public', 'Électronique'),
    (nextval('category_seq'), 'Produits pour la maison et le jardin', 'Maison & Jardin'),
    (nextval('category_seq'), 'Articles de sport et loisirs', 'Sport & Loisirs');


-- Insérer des produits dans la table product
INSERT INTO product (id, description, name, available_quantity, price, category_id)
VALUES
    (nextval('product_seq'), 'Téléviseur 4K Ultra HD de 55 pouces', 'Téléviseur', 10, 799.99, (SELECT id FROM category WHERE name = 'Électronique')),
    (nextval('product_seq'), 'Aspirateur robot intelligent', 'Aspirateur', 25, 299.99, (SELECT id FROM category WHERE name = 'Maison & Jardin')),
    (nextval('product_seq'), 'Tapis de yoga antidérapant', 'Tapis de yoga', 50, 29.99, (SELECT id FROM category WHERE name = 'Sport & Loisirs'));

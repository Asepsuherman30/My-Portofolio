WITH data_proses AS (
  -- Step 1: Validasi data numerik & tanggal
  SELECT *
  FROM `portofolio-project-465113.project_UMKM_portofolio.Penjualan`
  WHERE 
    Quantity > 0 AND 
    Price > 0 AND 
    Discount >= 0 AND 
    Order_Date IS NOT NULL
),

data_beri_nomor AS (
  -- Step 2: Beri nomor untuk menghapus duplikat Transaction_ID
  SELECT *, 
         ROW_NUMBER() OVER(PARTITION BY Transaction_ID ORDER BY Order_Date) AS row_num
  FROM data_proses
)

-- Step 3: Transformasi, normalisasi, dan urutkan tanggal
SELECT
  Transaction_ID,
  Customer_ID,
  Product_ID,
  UPPER(TRIM(Product_Name)) AS Product_Name_Clean,
  DATE(Order_Date) AS Order_Date,
  Quantity,
  Price,
  Discount,
  SAFE_CAST((Quantity * Price) - Discount AS NUMERIC) AS Total_Amount,
  INITCAP(TRIM(Payment_Method)) AS Payment_Method,
  INITCAP(TRIM(Delivery_City)) AS Delivery_City,
  INITCAP(TRIM(Delivery_Status)) AS Delivery_Status
FROM data_beri_nomor
WHERE row_num = 1
ORDER BY Order_Date;

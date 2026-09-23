from typing import List
from fastapi import APIRouter

router = APIRouter()

MOCK_CATEGORIES = [
    {"id": "cat-phones", "name": "Smartphones", "icon": "phone_iphone_rounded", "slug": "smartphones"},
    {"id": "cat-laptops", "name": "Laptops", "icon": "laptop_mac_rounded", "slug": "laptops"},
    {"id": "cat-tablets", "name": "Tablets", "icon": "tablet_mac_rounded", "slug": "tablets"},
    {"id": "cat-watches", "name": "Smartwatches", "icon": "watch_rounded", "slug": "smartwatches"},
    {"id": "cat-earbuds", "name": "Earbuds", "icon": "headphones_rounded", "slug": "earbuds"},
]

MOCK_BRANDS = [
    {"id": "b-apple", "name": "Apple", "device_count": 48, "category_slug": "smartphones"},
    {"id": "b-samsung", "name": "Samsung", "device_count": 62, "category_slug": "smartphones"},
    {"id": "b-oneplus", "name": "OnePlus", "device_count": 35, "category_slug": "smartphones"},
    {"id": "b-xiaomi", "name": "Xiaomi", "device_count": 55, "category_slug": "smartphones"},
    {"id": "b-google", "name": "Google", "device_count": 18, "category_slug": "smartphones"},
]

MOCK_MODELS = {
    "Apple": [
        {"id": "m-ip15p", "name": "iPhone 15 Pro", "base_max_price": 58000.0, "release_year": 2023},
        {"id": "m-ip14", "name": "iPhone 14", "base_max_price": 38000.0, "release_year": 2022},
        {"id": "m-ip13", "name": "iPhone 13", "base_max_price": 35000.0, "release_year": 2021},
        {"id": "m-ip12", "name": "iPhone 12", "base_max_price": 24000.0, "release_year": 2020},
    ],
    "Samsung": [
        {"id": "m-s23u", "name": "Galaxy S23 Ultra", "base_max_price": 54000.0, "release_year": 2023},
        {"id": "m-s22", "name": "Galaxy S22", "base_max_price": 31000.0, "release_year": 2022},
    ],
}


@router.get("/categories")
async def get_categories():
    return MOCK_CATEGORIES


@router.get("/brands")
async def get_brands(category: str = "smartphones"):
    return [b for b in MOCK_BRANDS if b["category_slug"] == category]


@router.get("/models")
async def get_models(brand: str = "Apple"):
    return MOCK_MODELS.get(brand, [])

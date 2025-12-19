#!/usr/bin/env python3
"""
Auto-generate Core Data Swift files from DataModel.xcdatamodel
Run: python3 generate_core_data_files.py
"""

import xml.etree.ElementTree as ET
from pathlib import Path
from datetime import datetime

# Configuration
BASE_DIR = Path(__file__).parent / "SmartCallBlock"
DATAMODEL_PATH = BASE_DIR / "DataModel.xcdatamodeld" / "DataModel.xcdatamodel" / "contents"

def parse_datamodel():
    """Parse DataModel.xcdatamodel XML"""
    tree = ET.parse(DATAMODEL_PATH)
    root = tree.getroot()
    return root

def swift_type_for_core_data(attr_type):
    """Map Core Data attribute type to Swift type"""
    type_map = {
        'String': 'String?',
        'Date': 'Date?',
        'Integer 32': 'Int32',
        'Integer 64': 'Int64',
        'Double': 'Double',
        'Float': 'Float',
        'Boolean': 'Bool',
        'Binary': 'Data?',
        'Decimal': 'NSDecimalNumber?',
    }
    return type_map.get(attr_type, 'String?')

def generate_class_file(entity_name):
    """Generate Entity+CoreDataClass.swift"""
    content = f"""//
//  {entity_name}+CoreDataClass.swift
//  SmartCallBlock
//
//  Auto-generated on {datetime.now().strftime('%m/%d/%Y')}
//

import Foundation
import CoreData

@objc({entity_name})
public class {entity_name}: NSManagedObject {{

}}
"""
    return content

def generate_properties_file(entity_name, attributes):
    """Generate Entity+CoreDataProperties.swift"""
    content = f"""//
//  {entity_name}+CoreDataProperties.swift
//  SmartCallBlock
//
//  Auto-generated on {datetime.now().strftime('%m/%d/%Y')}
//

import Foundation
import CoreData

extension {entity_name} {{

    @nonobjc public class func fetchRequest() -> NSFetchRequest<{entity_name}> {{
        return NSFetchRequest<{entity_name}>(entityName: "{entity_name}")
    }}

"""
    
    for attr in attributes:
        name = attr.get('name')
        attr_type = attr.get('attributeType')
        optional = attr.get('optional', 'YES') == 'YES'
        
        swift_type = swift_type_for_core_data(attr_type)
        content += f"    @NSManaged public var {name}: {swift_type}\n"
    
    content += "\n}\n"
    return content

def main():
    print(f"Parsing {DATAMODEL_PATH}...")
    
    if not DATAMODEL_PATH.exists():
        print(f"❌ DataModel not found at {DATAMODEL_PATH}")
        return 1
    
    root = parse_datamodel()
    
    # Find entities to generate
    entities = root.findall('.//entity')
    
    if not entities:
        print("❌ No entities found in DataModel")
        return 1
    
    generated_count = 0
    
    for entity in entities:
        entity_name = entity.get('name')
        attributes = entity.findall('.//attribute')
        
        if not attributes:
            print(f"⚠️  {entity_name}: No attributes, skipping")
            continue
        
        # Generate Class file
        class_file_path = BASE_DIR / f"{entity_name}+CoreDataClass.swift"
        class_content = generate_class_file(entity_name)
        class_file_path.write_text(class_content)
        print(f"✓ {class_file_path.name}")
        
        # Generate Properties file
        props_file_path = BASE_DIR / f"{entity_name}+CoreDataProperties.swift"
        props_content = generate_properties_file(entity_name, attributes)
        props_file_path.write_text(props_content)
        print(f"✓ {props_file_path.name}")
        
        generated_count += 1
    
    print(f"\n✅ Generated {generated_count * 2} files")
    return 0

if __name__ == '__main__':
    exit(main())

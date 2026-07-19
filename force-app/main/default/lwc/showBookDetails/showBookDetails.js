import { LightningElement, track, api } from 'lwc';
import getBookDetails from '@salesforce/apex/BookSearchService.fetchBookInfo';


export default class ShowBookDetails extends LightningElement {
    @track bookContents = { docs: [] };
    @track isLoading = false;
    @api bookname;
    
    // Internal private variable to store the book name state
    _selectedBookName = '';

    // 1. Declare the public property with a setter to watch for parent changes dynamically
    @api 
    get selectedBookName() {
        return this._selectedBookName;
    }

    set selectedBookName(value) {
        console.log('Setter received:', value);
        this._selectedBookName = value;
        // Automatically fetch new data every single time the parent updates this variable
        if (value) {
            this.fetchBookDetails(value);
        }
    }

    // 2. Lifecycle hook for initial component initialization setup
    connectedCallback() {
        // If the parent passes a value immediately on load, fetch it right away
        if (this.selectedBookName) {
            this.fetchBookDetails(this.selectedBookName);
        }
    }

    // 3. The async/await core engine that maps incoming payloads dynamically
    async fetchBookDetails(bookName) {
        this.isLoading = true;
        
        try {
            const result = await getBookDetails({ bookName: bookName });
            const rawDocs = typeof result === 'string' ? JSON.parse(result).docs : result.docs;

            if (!rawDocs) {
                this.bookContents.docs = [];
                return;
            }

            // Inspect and convert all primitive arrays dynamically
            this.bookContents.docs = rawDocs.map(doc => {
                const processedDoc = { ...doc };

                Object.keys(doc).forEach(key => {
                    if (Array.isArray(doc[key])) {
                        processedDoc[`mapped_${key}`] = doc[key].map((item, index) => ({
                            uniqueKey: `${doc.key || 'nokey'}-${key}-${index}`,
                            value: item
                        }));
                    }
                });

                return processedDoc;
            });

        } catch (error) {
            console.error('Error fetching book details: ', error);
        } finally {
            this.isLoading = false;
        }
    }
}